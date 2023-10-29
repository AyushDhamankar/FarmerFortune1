import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
function Transactions({ state }) {

  const params = useParams();
  const id = params.userId;
  console.log(id);

  const [d, setD] = useState("");
  useEffect(() => {
    const { contract } = state;
    if (!contract || !id) {
      return; // Exit if contract or userId is not available
    }
    const getDonor = async () => {
      const projects = await contract.methods
        .getTransactions(Number(id))
        .call();
      console.log(projects);
      const dataArray = projects[0].map((item, index) => ({
        id: index,
        value1: item,
        value2: projects[1][index],
        value3: projects[2][index],
        value4: projects[3][index],
        value5: projects[4][index],
      }));
      console.log(dataArray);
      setD(dataArray);
    };
    contract && getDonor();
  }, [state]);

  function shortenEthereumAddress(address) {
    const prefix = address.substring(0, 6);
    const suffix = address.substring(address.length - 3);
    return `${prefix}...${suffix}`;
  }
  return (
    <>
    <section class="text-gray-400 bg-gray-900 body-font overflow-hidden" style={{ minHeight: "90vh", }}>
        <div class="container px-5 py-24 mx-auto">
          <h1
            style={{
              display: "flex",
              justifyContent: "center",
              textAlign: "center",
              fontSize: "40px",
              fontWeight: "bolder",
              color: "white",
              marginBottom: "40px",
            }}
          >
            Transactions
          </h1>
          <div
            class="-my-8 divide-y-2 divide-gray-800"
            style={{
              display: "flex",
              flexDirection: "column",
              justifyContent: "center",
              textAlign: "center",
              backgroundColor: "#1a2331", 
              borderRadius: "35px",
            }}
          >
            {d !== "" &&
              d.map((item) => {
                console.log(item);
                return (
                  <div class="py-8 flex flex-wrap md:flex-nowrap">
                    <div class="md:flex-grow">
                      <h2 class="text-2xl font-medium text-white title-font mb-2">
                        From : {item.value2} {shortenEthereumAddress(item.value1)}
                      </h2>
                      <h2 class="text-2xl font-medium text-white title-font mb-2">
                        To : {item.value4} {shortenEthereumAddress(item.value3)}
                      </h2>
                      <h2 class="text-2xl font-medium text-white title-font mb-2">
                        Amount : {item.value5} XDC
                      </h2>
                    </div>
                  </div>
                );
              })}
          </div>
        </div>
      </section>
    </>
  );
}

export default Transactions;