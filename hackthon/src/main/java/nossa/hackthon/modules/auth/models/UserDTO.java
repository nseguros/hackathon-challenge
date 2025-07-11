package nossa.hackthon.modules.auth.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Getter @Setter
public class UserDTO {
    private String name;
    private String phone;
    private String email;
    private List<RoleDTO> roles;
}
