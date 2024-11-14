package fr.eseo.api.backend.controller;

import fr.eseo.api.backend.model.Activity;
import fr.eseo.api.backend.model.User;
import fr.eseo.api.backend.repository.ActivityRepository;
import fr.eseo.api.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/activities")
public class ActivityController {

    @Autowired
    private ActivityRepository activityRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping
    public ResponseEntity<Activity> saveActivity(@RequestBody Activity activity) {
        Optional<User> userOptional = userRepository.findById(activity.getUser().getId());
        if (userOptional.isPresent()) {
            activity.setUser(userOptional.get());
            Activity savedActivity = activityRepository.save(activity);
            return new ResponseEntity<>(savedActivity, HttpStatus.CREATED);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Activity>> getActivitiesByUserId(@PathVariable Long userId) {
        List<Activity> activities = activityRepository.findByUserId(userId);
        return ResponseEntity.ok(activities);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteActivity(@PathVariable Long id) {
        if (activityRepository.existsById(id)) {
            activityRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}