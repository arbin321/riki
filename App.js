
import { useState } from 'react';
import { useSelector } from 'react-redux';
import { Link, Route, Routes } from 'react-router-dom';
import AddToDo from './AddToDo';
//import './App.scss';
import Dialoge from './Dialoge';
import History from './History';
import Login from './Login';
import Logout from './Logout';
import Register from './Register';
import Search from './Search';
import ToDo from './ToDo';
import ToDos from './ToDos';

function App() {

// const [user, setUser] = useState(
  let user=useSelector(state => state.currentUser)
  // );
  return (
    <div className="App">
      
      <nav>
        <Link className='link' to={"/login"}>Sign in</Link>
        <Link className='link' to={"/register"}>Sign up</Link>
        {user&&<Link className='link' to={"/todo"}>Todo</Link>}
        {user&&<Link className='link' to={"/history"}>History</Link>}
        {user&&<Link className='link' to={"/addtodo"}>Add task</Link>}
        {user&&<Link className='link' to={"/logout"}>Log Out</Link>}
        {user&&<Search/>}
      </nav>
     
      <Routes>
        <Route path="/" element={<Login />}>
        </Route>
        <Route path="logout" element={<Logout />}/>
        <Route path="login" element={<Login />}></Route>
        <Route path="todo"  element={user&&<ToDos />} >
        <Route path="addtodo"  element={user&&<AddToDo />} />
        </Route>
        <Route path="addtodo"  element={user&&<AddToDo />} />
        <Route path="history"  element={user&&<History />} />
        <Route path="register" element={<Register />} >
        </Route>
        <Route path="dialoge" element={user&&<Dialoge />} />
        <Route path="*"
          element={
            <main style={{ padding: "1rem" }}>
              <p>There's nothing here!</p>
            </main>} />
      </Routes>
    </div>
  );
}

export default App;
