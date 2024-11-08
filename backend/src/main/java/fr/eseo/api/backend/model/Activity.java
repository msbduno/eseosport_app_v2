package fr.eseo.api.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "activities")
@Data
@NoArgsConstructor
public class Activity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_activity")
    private Long idActivity;

    @Column(nullable = false)
    private LocalDateTime date;

    private Integer duration;
    private Double distance;
    private Double elevation;
    private Double averageSpeed;
    private Integer averageBPM;
    private String comment;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}