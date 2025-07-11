package nossa.hackthon.modules.users;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import nossa.hackthon.common.GenericValues;

import java.util.ArrayList;
import java.util.List;

/**
 * Entity representing a user in the system.
 */
@Entity
@Getter
@Setter
@Table(name = "nossa_users")
public class User extends GenericValues {

    @NotBlank(message = "Name is required")
    @Size(min = 3, max = 100, message = "Name must be between 3 and 100 characters")
    private String name;

    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^\\+?[0-9]{9,15}$", message = "Invalid phone number format")
    private String phone;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    @Column(unique = true)
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Identity is required")
    @Column(unique = true)
    private String identity;

    private String identity_type;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "nossa_user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private List<Role> roles = new ArrayList<>();

    /**
     * Adds a role to the user if it doesn't already exist
     * 
     * @param role The role to add
     */
    public void addRole(Role role) {
        if (roles == null) {
            roles = new ArrayList<>();
        }
        if (!roles.contains(role)) {
            roles.add(role);
        }
    }
}
