import AppBar from '@mui/material/AppBar';
import CssBaseline from '@mui/material/CssBaseline';
import Grid from '@mui/material/Grid';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import ProductCard from '../../components/ProductCard';
import { useQuery } from '@tanstack/react-query'


export default function Cart() {
      const token = localStorage.getItem('token');
      console.log('token', token)
      const { isPending, error, data:orders } = useQuery({
        queryKey: ['orders'],
        queryFn: () =>
          fetch('http://localhost:3001/orders', {
            method: 'GET',
            headers: {
              'Authorization': `Bearer ${token}`, // Include the token in the Authorization header
              'Content-Type': 'application/json',
              // Add any other headers if required
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
      <AppBar position="relative">
        <Toolbar>
          {/* <CameraIcon sx={{ mr: 2 }} /> */}
          <Typography variant="h6" color="inherit" noWrap>
            Cart
          </Typography>
        </Toolbar>
      </AppBar>
      <main>
        <Container sx={{ py: 8 }} maxWidth="md">
          <Grid container spacing={4}>
            {orders?.map((product) => (
              <ProductCard product={product} key={product.id} showRemoveFromCartButton={true} showQuantity={true} />
            ))}
          </Grid>
        </Container>
      </main>
    </>
  );
}