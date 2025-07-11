package nossa.hackthon.modules.users;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class SedderUsers implements ApplicationRunner {
    private final UserRepository repository;
    private final RoleRepository roleRepository;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        createDefaultRole();
        createDefaultUser();
    }
    void createDefaultRole(){
        var role = new Role();
        role.setName("ROLE_CLIENT");
        role.setDescription("Role Client");
        if (!roleRepository.existsByName(role.getName())) {
            roleRepository.save(role);
        }
    }

    void createDefaultUser() {
        var user  = new User();
        user.setName("User Nossa");
        user.setEmail("client@nossa.ao");
        user.setPassword("$2a$10$Knl9xg11ODzBjwYIutChd.nGmy6WMjPg/gsHQLnyTVSZi4nJrbIQa");
        user.setIdentity("00840324555LA042");
        user.setPhone("923000000");
        user.setRoles(List.of(roleRepository.findByName("ROLE_CLIENT").orElse(new Role())));
        if (!repository.existsByEmailOrPhone(user.getEmail(), user.getPhone())) {
            repository.save(user);
        }
    }



}
