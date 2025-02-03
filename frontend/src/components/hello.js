import React, { useState, useEffect } from 'react';
import axios from 'axios';

function Hello() {
  const [apiResponse, setApiResponse] = useState("");

  useEffect(() => {
    axios.get("http://localhost:3000/messages/hello")
      .then((response) => {
        console.log('Full response:', response);
        setApiResponse(response.data.content);
      })
      .catch((error) => {
        console.error('error:', error);
        setApiResponse("Error fetching data");
      });
  }, []);

  return (
    <div>
      <h1>{apiResponse || "Loading..."}</h1>
    </div>
  );
}

export default Hello;
