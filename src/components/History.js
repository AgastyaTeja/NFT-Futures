import React, { useState, useEffect } from "react";
import { Table, Container, Button } from "react-bootstrap";
import punk from "../Assets/punks.png";
import bayc from "../Assets/bayc.png";
import doodles from "../Assets/doodles.jpg";
import { useNavigate } from "react-router-dom";
import { getHistory } from "./Utils";

const History = () => {
  const [history, setHistory] = useState([]);

  useEffect(() => {
          const getData = async () => {
            const data = await getHistory();
            setHistory(data);
          };
          getData();
  }, []);

  return (
    <div>
      <div className="text-center mt-5">
        <h4>History</h4>
      </div>
      <div></div>
      <Container>
        <Table striped>
          <thead>
            <tr>
              <th>#</th>
              <th>NFT set</th>
              <th>Floor Price</th>
              <th>Volume</th>
              <th>Unique Users</th>
              <th>Total Bets</th>
              <th>Bet</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                {" "}
                <img src={punk} style={{ height: "100px", width: "100px" }} />
              </td>
              <td>CrytoPunks</td>
              <td>50 eth</td>
              <td>908.1k eth</td>
              <td>5.2k</td>
              <td>3</td>
              <td>
                <Button
                  variant="secondary"
                  className="align-middle"
                  onClick={(event) => (window.location.href = "/betPunks")}
                >
                  Place a bet
                </Button>{" "}
              </td>
            </tr>
            {
                history.forEach(bet => {
                         <tr>
                           <td>
                             {" "}
                             <img
                               src={punk}
                               style={{ height: "100px", width: "100px" }}
                             />
                           </td>
                           <td>bet[1]</td>
                           <td>bet[2]</td>
                           <td></td>
                           <td>5.2k</td>
                           <td>3</td>
                           <td>
                             <Button
                               variant="secondary"
                               className="align-middle"
                               onClick={(event) =>
                                 (window.location.href = "/betPunks")
                               }
                             >
                               Place a bet
                             </Button>{" "}
                           </td>
                         </tr>;
                })
            }
          </tbody>
        </Table>
      </Container>
    </div>
  );
};

export default History;
