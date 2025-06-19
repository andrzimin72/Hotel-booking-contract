import { useEffect, useState } from "react";
import Web3Modal from "web3modal";
import { ethers } from "ethers";
import hotelAbi from "../contracts/Hotel.json";

const useContract = () => {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [contract, setContract] = useState(null);

  useEffect(() => {
    const connectWallet = async () => {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(hotelAbi.address, hotelAbi.abi, signer);

      setProvider(provider);
      setSigner(signer);
      setContract({ provider, signer, contract });
    };

    if (!contract) connectWallet();
  }, []);

  return contract;
};

export default useContract;