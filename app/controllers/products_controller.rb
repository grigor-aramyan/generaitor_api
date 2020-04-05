class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:list]

  def create
    if current_user.accountable_type != 'Organization'
      render json: {
        data: {
          msg: 'Only organizations can add products'
        }
      }, status: 400
    else
      new_product = current_user.accountable.products.create(product_create_params(params))

      if new_product.id > 0
        render json: {
          data: {
            msg: 'Created'
          }
        }, status: 201
      else
        render json: {
          data: {
            msg: 'Failed! Contact with us, please!'
          }
        }, status: 400
      end
    end

  end

  def list
    render json: {
      data: {
        msg: 'listed for ' + params[:company]
      }
    }, status: 200
  end

  private
    def product_create_params(params)
      params.require(:product).permit(:title, :description, :img_uri)
    end
end
