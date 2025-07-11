package nossa.hackthon.modules.users.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import nossa.hackthon.modules.users.User;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Simplified DTO for User information in nested responses
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserSummaryDTO {
    private UUID id;
    private String name;
    private String email;
    private String phone;
    private String identity;
    private LocalDateTime createdAt;
    
    /**
     * Convert entity to DTO
     * 
     * @param user The user entity
     * @return UserSummaryDTO
     */
    public static UserSummaryDTO fromEntity(User user) {
        UserSummaryDTO dto = new UserSummaryDTO();
        dto.setId(user.getId());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        dto.setPhone(user.getPhone());
        dto.setIdentity(user.getIdentity());
        dto.setCreatedAt(user.getCreatedAt());
        return dto;
    }
} 