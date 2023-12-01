import PropTypes from 'prop-types'
import React from 'react'
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Grid from '@mui/material/Grid';
import Typography from '@mui/material/Typography';
import { useQueryClient, useMutation} from '@tanstack/react-query'
import {  useNavigate } from "react-router-dom";


export const ProductCard = ({product, showAddToCartButton = false, showRemoveFromCartButton = false, showQuantity = false, page="cart"}) => {
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const token = localStorage.getItem('token');
  const addToCart = async (product) =>{
    try {
      const body = {
        "product_id": product.id,
        "price": product.price,
        "quantity": 1
      }
      return fetch('http://localhost:3001/orders', {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${token}`, // Include the token in the Authorization header
              'Content-Type': 'application/json',
              // Add any other headers if required
            },
            body: JSON.stringify(body),
          }).then(
            (res) => res.json(),
          )
    } catch (error) {
      // Handle network or other errors
      console.error('Error:', error);
    }
  }
  const removeFromCart = async(product)=>{
      const body = {
        "product_id": `${product.id}`
      }

      return fetch('http://localhost:3001/orders', {
            method: 'DELETE',
            headers: {
              'Authorization': `Bearer ${token}`, // Include the token in the Authorization header
              'Content-Type': 'application/json',
              // Add any other headers if required
            },
            body: JSON.stringify(body),
          }).then(
            (res) => res.json(),
          )
    
  }

  const mutation = useMutation({
    mutationFn: addToCart,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] })
      navigate('/cart')
    },
  })

  const mutateRemoveFromCart = useMutation({
    mutationFn: removeFromCart,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] })
    },
  })

  
  return (
    <Grid item xs={12} sm={6} md={4} 
    // onClick={()=>navigate(`/product/${product.id}`)}
    >
                <Card
                  sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}
                >
                  <CardMedia
                    component="div"
                    sx={{
                      // 16:9
                      pt: '56.25%',
                    }}
                    image={product.images_urls[0]}
                  />
                  <CardContent sx={{ flexGrow: 1 }}>
                    <Typography gutterBottom variant="h5" component="h2">
                      {product.name}
                    </Typography>
                    <Typography gutterBottom>
                      {product.description}
                    </Typography>
                    {showQuantity && (<Typography gutterBottom>
                      {`Quantity: ${product.quantity}`}
                    </Typography>)}                
                    <Typography variant="h5">
                      {product.price}
                    </Typography>
                  </CardContent>
                  <CardActions>
                  {showAddToCartButton &&( 
                    <>
                      <Button size="small" onClick={()=>mutation.mutate(product)}>Add to Cart</Button>
                      <Button size="small">Buy</Button>
                    </>
                    )}
                    {showRemoveFromCartButton &&( 
                      <Button size="small" onClick={()=>mutateRemoveFromCart.mutate(product)}>Remove from Cart</Button>
                    )}
                  </CardActions>
                </Card>
              </Grid>
  )
}

ProductCard.propTypes = {
  product: PropTypes.object.isRequired,
  showAddToCartButton: PropTypes.bool,
  showRemoveFromCartButton: PropTypes.bool,
  showQuantity: PropTypes.bool,
  page: PropTypes.string,
}

export default ProductCard