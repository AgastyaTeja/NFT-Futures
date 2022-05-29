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
            setHistory([...data].reverse());
          };
          getData();
  }, []);

  function timeConverter(UNIX_timestamp) {
    var a = new Date(UNIX_timestamp * 1000);
    var months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    var year = a.getFullYear();
    var month = months[a.getMonth()];
    var date = a.getDate();
    var hour = a.getHours();
    var min = a.getMinutes();
    var sec = a.getSeconds();
    var time =
      date + " " + month + " " + year + " " + hour + ":" + min + ":" + sec;
    return time;
  }

  return (
    <div>
        <Container>
            <Table striped responsive="md">
            <thead>
                <tr>
                <th>#</th>
                <th>NFT set</th>
                <th>Closing Value</th>
                <th>Status</th>
                <th>User 1</th>
                <th>User 2</th>
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
                    <td>{parseInt(bet.closingPropertyValue._hex, 16)/10**18}</td>
                    <td>{bet.status === 2 ? "Completed" : "Open"}</td>
                    <td className="col-1 text-truncate ">{bet.userBid1.user.substring(0, 7)}...</td>
                    <td className="col-1 text-truncate">{bet.userBid2.user.substring(0, 7)}...</td>
                    <td>{timeConverter(parseInt(bet.startTime))}</td>
                    <td>{bet.winner.substring(0, 7)}...</td>
                </tr>
                ))}
            </tbody>
            </Table>
        </Container>
    </div>
  );
};

export default History;
