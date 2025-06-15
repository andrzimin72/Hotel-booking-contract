import React, { useState } from "react";

const BookingForm = ({ contract, account }) => {
  const [days, setDays] = useState(1);
  const [date, setDate] = useState("");

  const buyTokens = async () => {
    const price = await contract.contract.getEthPriceForTokens(days);
    await contract.contract.buyTokens(days, { value: price });
    alert("✅ Tokens bought!");
  };

  const bookAppointment = async () => {
    const timestamp = Math.floor(new Date(date).getTime() / 1000);
    await contract.contract.bookAppointment("User", timestamp, days);
    alert("✅ Appointment booked!");
  };

  return (
    <div style={{ margin: "2rem auto", maxWidth: "400px" }}>
      <h2>Book Your Stay</h2>
      <input
        type="number"
        placeholder="Number of days"
        min="1"
        value={days}
        onChange={(e) => setDays(parseInt(e.target.value))}
      />
      <br /><br />
      <label>Select Start Date:</label>
      <input
        type="date"
        onChange={(e) => setDate(e.target.value)}
      />
      <br /><br />
      <button onClick={buyTokens}>Buy {days} Tokens</button>
      <br /><br />
      <button onClick={bookAppointment}>Book Appointment</button>
    </div>
  );
};

export default BookingForm;