import AppBar from '@mui/material/AppBar';
import CssBaseline from '@mui/material/CssBaseline';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import {useQuery} from '@tanstack/react-query'
import {  useNavigate, useParams } from 'react-router-dom';

export default function Product() {
  const token = localStorage.getItem('token');
  const navigate = useNavigate();
  const {id} = useParams()
      const { isPending, error, data:product } = useQuery({
        queryKey: ['product'],
        queryFn: () =>
          fetch(`http://localhost:3002/products/${id}`, {
            method: 'GET',
            headers: {
              'Authorization': `Bearer ${token}`, // Include the token in the Authorization header
              'Content-Type': 'application/json',
            },
          }).then(
            (res) => res.json(),
          ),
      })
  if (isPending) return <>'Loading...'</>

  if (error) return <>{`An error has occurred: ${error.message}`}</>
  
  return (
    <>
      <CssBaseline />
      <AppBar position="relative" >
        <Toolbar>
          <Typography variant="h6" color="inherit" noWrap onClick={()=>navigate('/')}>
            Home
          </Typography>
        </Toolbar>
      </AppBar>
      <main>
        <Container sx={{ py: 8, display:'flex', justifyContent: 'space-between', gap:'20px'  }} maxWidth="md">
          <div style={{width:'50%'}}>
            <img style={{height: '100%', width: '100%'}} src={product.images_urls[0]} alt={product.name}/>
          </div>
          <div style={{width:'50%'}}>
            <h2>{product.name}</h2>
            <h3>{product.description}</h3>
            <h2>{product.price}</h2>
          </div>
        </Container>
      </main>
    </>
  );
}