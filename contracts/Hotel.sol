// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DateTime.sol";
import "./BookingToken.sol";

contract Hotel {
    using SafeMath for uint256;
    using SafeMath for uint64;

    BookingToken public bookingToken;
    DateTime private dateTime;

    bool private useFixedPricing;
    address payable public owner;
    uint64 public bookingTokenPrice;
    uint256 public CONTRACT_DEPLOY_TIME;

    AggregatorV3Interface internal priceFeed;

    struct Appointment {
        bool isAppointment;
        string partyName;
        address userAddress;
    }

    struct UserBooking {
        uint256 timestamp;
        uint8 numDays;
    }

    mapping(uint256 => Appointment) public scheduleByTimestamp;
    mapping(address => UserBooking[]) public userBookings;

    event OwnerChanged(address indexed from, address to);
    event TokenPriceChanged(uint64 oldPrice, uint64 newPrice);
    event TokenBought(address indexed from, uint256 sum, uint64 price);
    event AppointmentScheduled(address indexed from, uint256 timestamp, uint256 sum);
    event AppointmentRefunded(address indexed from, uint256 timestamp, uint256 sum);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier validNumDays(uint8 _num) {
        require(_num > 0 && _num <= 30, "Must be between 1 - 30");
        _;
    }

    constructor(
        uint64 _initialPrice,
        address _priceContractAddr,
        bool _useFixedPricing
    ) {
        useFixedPricing = _useFixedPricing;
        CONTRACT_DEPLOY_TIME = block.timestamp;
        bookingToken = new BookingToken(address(this));
        owner = payable(msg.sender);
        priceFeed = AggregatorV3Interface(_priceContractAddr);
        dateTime = new DateTime();
        bookingTokenPrice = _initialPrice;
    }

    function validateTimestamp(uint256 _t) private view {
        require(_t > CONTRACT_DEPLOY_TIME, "Before contract deploy time");
        require(_t % 86400 == 0, "Timestamp must be mod 86400");
    }

    function getUnixTimestamp(uint8 _month, uint8 _day, uint16 _year)
        public
        view
        returns (uint256)
    {
        return dateTime.toTimestamp(_year, _month, _day);
    }

    function getTokenBalance(address _address) public view returns (uint256) {
        return bookingToken.balanceOf(_address);
    }

    function getAppointmentsByUser(address _addr)
        public
        view
        returns (UserBooking[] memory)
    {
        return userBookings[_addr];
    }

    function getRangeAvailability(uint256 _start, uint8 _numDays)
        public
        view
        returns (address[] memory)
    {
        require(_numDays > 0 && _numDays <= 365, "Invalid range");
        address[] memory monthlyAppointments = new address[](_numDays);
        for (uint8 i = 0; i < _numDays; i++) {
            Appointment memory appt = scheduleByTimestamp[
                _start + (i * 86400)
            ];
            monthlyAppointments[i] = appt.isAppointment ? appt.userAddress : address(0);
        }
        return monthlyAppointments;
    }

    function bookAppointment(
        string memory _name,
        uint256 _timestamp,
        uint8 _numDays
    ) public validNumDays(_numDays) {
        bookingToken.burn(msg.sender, _numDays);
        for (uint8 i = 0; i < _numDays; i++) {
            uint256 currDay = _timestamp + (i * 86400);
            require(scheduleByTimestamp[currDay].isAppointment == false, "Date already booked");
            scheduleByTimestamp[currDay] = Appointment(true, _name, msg.sender);
        }
        userBookings[msg.sender].push(UserBooking(_timestamp, _numDays));
        emit AppointmentScheduled(msg.sender, _timestamp, _numDays);
    }

    function refundAppointment(uint8 _index) public {
        UserBooking memory booking = userBookings[msg.sender][_index];
        require(booking.timestamp > block.timestamp, "Event already passed");

        for (uint8 i = 0; i < booking.numDays; i++) {
            uint256 currDay = booking.timestamp + (i * 86400);
            require(scheduleByTimestamp[currDay].userAddress == msg.sender, "Not your booking");
            scheduleByTimestamp[currDay].isAppointment = false;
        }

        userBookings[msg.sender][_index] = userBookings[msg.sender][userBookings[msg.sender].length - 1];
        userBookings[msg.sender].pop();

        bookingToken.mint(msg.sender, booking.numDays);
        emit AppointmentRefunded(msg.sender, booking.timestamp, booking.numDays);
    }

    function passOwnerRole(address _owner) public onlyOwner {
        owner = payable(_owner);
        emit OwnerChanged(msg.sender, _owner);
    }

    function changeTokenPrice(uint64 _newPrice) public onlyOwner {
        emit TokenPriceChanged(bookingTokenPrice, _newPrice);
        bookingTokenPrice = _newPrice;
    }

    function returnPrice() internal view returns (int256) {
        int256 fallbackValue = 1000 * 1e8;
        if (useFixedPricing) return fallbackValue;

        try priceFeed.latestRoundData() returns (
            uint80,
            int256 price,
            uint256,
            uint256,
            uint80
        ) {
            return price;
        } catch {
            return fallbackValue;
        }
    }

    function getEthPriceForTokens(uint256 _numTokens)
        public
        view
        returns (uint256)
    {
        int256 rawEthToUsdPrice = returnPrice();
        require(rawEthToUsdPrice >= 0, "Negative ETH price");

        uint256 ethToUsdPrice = uint256(rawEthToUsdPrice).div(1e8);
        uint256 priceFor1Token = (bookingTokenPrice * 1e18) / ethToUsdPrice;
        return priceFor1Token * _numTokens;
    }

    function buyTokens(uint256 _numTokens) public payable {
        uint256 etherPrice = getEthPriceForTokens(_numTokens);
        require(msg.value >= etherPrice, "Not enough Ether");

        bookingToken.mint(msg.sender, _numTokens);
        (bool sent, ) = owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        emit TokenBought(msg.sender, _numTokens, bookingTokenPrice);
    }
}
