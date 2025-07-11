package nossa.hackthon.modules.users;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import nossa.hackthon.common.GenericValues;

import java.util.List;

/**
 * Entity representing a user role in the system.
 * Roles are used for authorization and access control.
 */
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "nossa_roles")
@JsonIgnoreProperties({"users"})
public class Role extends GenericValues {
    
    @Column(nullable = false, unique = true)
    private String name;
    
    private String description;
    
    @ManyToMany(mappedBy = "roles")
    private List<User> users;
    
    /**
     * Predefined system roles
     */
    public static final String ROLE_ADMIN = "ROLE_ADMIN";
    public static final String ROLE_MANAGER = "ROLE_MANAGER";
    public static final String ROLE_USER = "ROLE_USER";
}