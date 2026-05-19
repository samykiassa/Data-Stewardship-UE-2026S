# Entity-Relationship Diagram Description
Since we cannot generate a graphical ER diagram purely with a shell script directly into a standard format, the ER diagram is described theoretically based on the 3NF SQL definitions:

- **accident**: Contains core event attributes (`reference_number`, `date`, `time`, `location`). Relates to `weather`, `lighting`, `road_surface`, `road_class` (many-to-one).
- **person**: Contains `person_id`, `age`, and links to `sex`.
- **accident_casualty**: The associative/junction entity linking an `accident` and a `person`. Resolves the many-to-many relationship. It stores casualty specific attributes like `casualty_class`, `casualty_severity`, and `vehicle_id`.
- **cheese_consumption**: Spurious data table linked to accidents implicitly via `Year(date)`.

See `docs/ER_diagram_and_schema.sql` for exact DDL statements. An explicit image representation (`entityRelationshipModel_20260513.jpg`) is provided via the repository if it already exists or was attached.
