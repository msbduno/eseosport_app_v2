package fr.eseo.api.backend.service;

import fr.eseo.api.backend.model.Activity;
import fr.eseo.api.backend.repository.ActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ActivityService {
    private final ActivityRepository activityRepository;

    public Activity createActivity(Activity activity, Long userId) {
        return activityRepository.save(activity);
    }

    public Optional<Activity> getActivityById(Long id) {
        return activityRepository.findById(id);
    }

    public List<Activity> getActivitiesByUserId(Long userId) {
        return activityRepository.findByUserId(userId);
    }

    public Activity updateActivity(Long id, Activity activityDetails) {
        Activity activity = activityRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Activity not found"));

        activity.setDate(activityDetails.getDate());
        activity.setDuration(activityDetails.getDuration());
        activity.setDistance(activityDetails.getDistance());
        activity.setElevation(activityDetails.getElevation());
        activity.setAverageSpeed(activityDetails.getAverageSpeed());
        activity.setAverageBPM(activityDetails.getAverageBPM());
        activity.setComment(activityDetails.getComment());

        return activityRepository.save(activity);
    }

    public void deleteActivity(Long id) {
        activityRepository.deleteById(id);
    }
        public List<Activity> getAllActivities() {
            return activityRepository.findAll();
        }


}
