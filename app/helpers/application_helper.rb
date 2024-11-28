module ApplicationHelper
    # Método para cargar YAML de manera segura
    def safe_load_yaml(yaml_data)
      begin
        YAML.safe_load(yaml_data, permitted_classes: [ActiveSupport::TimeWithZone], aliases: true)
      rescue Psych::DisallowedClass, Psych::SyntaxError
        {}
      end
    end
  end