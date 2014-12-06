module Api
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      resource_saved = resource.save
      if resource_saved
        if resource.active_for_authentication?
          # set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          render status: :created
        else
          # set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        if @validatable
          @minimum_password_length = resource_class.password_length.min
        end
        render json: {errors: resource.errors.full_messages}, status: :unprocessable_entity
      end

    end

  end
end