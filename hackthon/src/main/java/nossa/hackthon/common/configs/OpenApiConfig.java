package nossa.hackthon.common.configs;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI nossaOpenAPI() {

        Contact contact = new Contact();
        contact.setEmail("info@nossa.dev.com");
        contact.setName("Nossa Hackthon API Support");
        contact.setUrl("https://www.nossaseguros.ao/");

        License mitLicense = new License()
                .name("License")
                .url("https://www.nossaseguros.ao/licenses/");

        Info info = new Info()
                .title("NOSSA HACKATHON API")
                .version("0.0.3")
                .contact(contact)
                .description("This API exposes endpoints for NOSSA HACKTHON.")
                .license(mitLicense);

        SecurityScheme securityScheme = new SecurityScheme()
                .name("Bearer Authentication")
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .description("Enter JWT token");

        SecurityRequirement securityRequirement = new SecurityRequirement().addList("Bearer Authentication");

        return new OpenAPI()
                .info(info)
                .addSecurityItem(securityRequirement)
                .components(new io.swagger.v3.oas.models.Components()
                        .addSecuritySchemes("Bearer Authentication", securityScheme));
    }
}
