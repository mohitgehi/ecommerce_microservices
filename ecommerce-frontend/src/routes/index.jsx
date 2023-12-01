import {
  createBrowserRouter,
} from "react-router-dom";
import Login from '../pages/Login';
import Register from '../pages/Register';
import Home from '../pages/Home';
import Cart from '../pages/Cart';
import Product from '../pages/Product';

export const router = createBrowserRouter([
  {
    path: "/",
    element: <Home/>,
  },
  {
    path: '/login',
    element: <Login/>
  },
  {
    path: '/register',
    element: <Register/>
  },
  {
    path: '/cart',
    element: <Cart/>
  },
  {
    path: '/product/:id',
    element: <Product/>
  }
]);