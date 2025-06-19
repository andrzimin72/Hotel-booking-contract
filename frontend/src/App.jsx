import React from "react";
import useContract from "./hooks/useContract";
import ConnectButton from "./components/ConnectButton";
import BookingForm from "./components/BookingForm";

function App() {
  const contract = useContract();
  const [account, setAccount] = React.useState("");

  React.useEffect(() => {
    const getAccount = async () => {
      if (contract?.signer) {
        const addr = await contract.signer.getAddress();
        setAccount(addr);
      }
    };
    getAccount();
  }, [contract]);

  return (
    <div className="App">
      <ConnectButton account={account} />
      <h1 style={{ textAlign: "center" }}>🏨 Decentralized Hotel Booking</h1>
      {account ? (
        <BookingForm contract={contract} account={account} />
      ) : (
        <p style={{ textAlign: "center" }}>Please connect your wallet</p>
      )}
    </div>
  );
}

export default App;