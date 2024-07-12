// import logo from './logo.svg';
import './App.css';
// import { Routes } from './Routes';
import {BrowserRouter as Router, Routes ,Route} from "react-router-dom";
import { NotFoundPage } from './pages/NotFoundPage';
import { HomePage } from './pages/HomePage';
import { ProfilePage } from './pages/ProfilePage';
// import { Route } from 'react-router-dom';

function App() {
  return (
    <Router>
      <Routes>
        <Route path='/NotFoundPage' element={<NotFoundPage />} />
        <Route path='/' element={<HomePage />} />
        <Route path='/profile' element={<HomePage />} />
      </Routes>
    </Router>
  );
}

export default App;
