import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { MetaHeader } from "~~/components/MetaHeader";
import { Address, Balance } from "~~/components/scaffold-eth";
import { useDeployedContractInfo, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { address } = useAccount();

  const { data: yourContractInfo } = useDeployedContractInfo("YourContract");

  const { data: timeLeft } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "timeLeft",
  });

  const { data: round } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "round",
  });

  const { data: isPlayer } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "player",
    args: [address],
  });

  const { writeAsync: checkIn } = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "checkIn",
  });

  const button = (
    <button
      disabled={timeLeft?.toString() != "0"}
      className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-25"
      onClick={async () => {
        checkIn();
      }}
    >
      Checkin
    </button>
  );

  return (
    <>
      <MetaHeader />
      <div className="flex gap-4 items-center flex-col flex-grow pt-10">
        <Address address={address} />
        <div>Time left: {timeLeft?.toString()}s</div>
        <div>Round: {round?.toString()}</div>
        <div>
          {" "}
          ETH in contract: <Balance address={yourContractInfo?.address} />
        </div>

        {isPlayer ? button : "You are not a player"}
      </div>
    </>
  );
};

export default Home;
