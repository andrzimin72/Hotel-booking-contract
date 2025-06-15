import React from "react";

const ConnectButton = ({ account }) => {
  return (
    <div style={{ textAlign: "right", padding: "1rem" }}>
      {account ? (
        <span>Connected: {account.slice(0, 6)}...{account.slice(-4)}</span>
      ) : (
        <button onClick={() => window.location.reload()}>
          🔐 Connect Wallet
        </button>
      )}
    </div>
  );
};

export default ConnectButton;