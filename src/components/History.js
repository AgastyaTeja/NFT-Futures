import React, { useState, useEffect } from "react";
import { Table, Container, Button } from "react-bootstrap";
import punk from "../Assets/punks.png";
import bayc from "../Assets/bayc.png";
import doodles from "../Assets/doodles.jpg";
import { useNavigate } from "react-router-dom";
import { getHistory } from "./Utils";
/* global BigInt */

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
              <th>Closing Value</th>
              <th>Status</th>
              <th>Start Time</th>
              <th>Winner</th>
            </tr>
          </thead>
          <tbody>
            {history.map((bet) => (
              <tr>
                <td>
                  {" "}
                  <img src={punk} style={{ height: "100px", width: "100px" }} />
                </td>
                <td>{bet.nftCollection}</td>
                <td>{parseInt(bet.closingPropertyValue._hex, 16)}</td>
                <td>{bet.status === 2 ? "Completed" : "Open"}</td>
                <td>{bet.status === 2 ? "Completed" : "Open"}</td>
                <td>{bet.winner}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Container>
    </div>
  );
};

export default History;
