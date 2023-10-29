import {useState} from 'react';
import Navbar from './Components/Navbar/Navbar';
import Hero from './Components/Hero/Hero';
import Register from './Components/Register/Register';
import Farmer_Create from './Components/Farmer/Farmer_Create';
import Farmer_Post from './Components/Farmer/Farmer_Post';
import Farmer_Own_Post from './Components/Farmer/Farmer_Own_Post';
import Transactions from './Components/Farmer/Transactions';
import { BrowserRouter as Router,Routes, Route } from 'react-router-dom';

function App() {
  const [state, setState] = useState({
    web3:null,
    contract:null
  })
  const [state1, setState1] = useState({
    web3:null,
    contract:null
  })
  const [state2, setState2] = useState({
    web3:null,
    contract:null
  })
  const saveState = (state) => {
    console.log(state);
    setState(state);
  }
  const saveState1 = (state1) => {
    console.log(state1);
    setState1(state1);
  }
  const saveState2 = (state2) => {
    console.log(state2);
    setState2(state2);
  }
  return (
    <>
    <Router>
        <Navbar saveState={saveState} saveState1={saveState1} saveState2={saveState2}></Navbar>
           <Routes>
                <Route exact path='/' element={< Hero />}></Route>
                <Route exact path='/register' element={< Register state={state} />}></Route>
                <Route exact path='/farmer_create' element={< Farmer_Create state={state1} />}></Route>
                <Route exact path='/farmer_post' element={< Farmer_Post state={state1} />}></Route>
                <Route exact path='/farmer_own_post' element={< Farmer_Own_Post state={state1} />}></Route>
                <Route path="transactions">
                  <Route path=":userId" element={<Transactions state={state1} />} />
                </Route>
          </Routes>
      </Router>
    </>
  );
}

export default App;