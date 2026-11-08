enum TipoEvento {
  academico('Académico'),
  corporativo('Corporativo');

  const TipoEvento(this.etiqueta);
  final String etiqueta;
}

enum ModalidadEvento {
  presencial('Presencial'),
  virtual('Virtual'),
  hibrido('Híbrido');

  const ModalidadEvento(this.etiqueta);
  final String etiqueta;
}

class Evento {
  const Evento({
    required this.nombre,
    required this.fecha,
    required this.inscritos,
    required this.cupoMaximo,
    required this.tipo,
    required this.modalidad,
  });

  final String nombre;
  final DateTime fecha;
  final int inscritos;
  final int cupoMaximo;
  final TipoEvento tipo;
  final ModalidadEvento modalidad;
}

// Datos de ejemplo tomados del diseño en Figma, hasta conectar la tabla de eventos.
final eventosDemo = <Evento>[
  Evento(
    nombre: 'Congreso de Ingeniería de Software 2026',
    fecha: DateTime(2026, 3, 14),
    inscritos: 45,
    cupoMaximo: 100,
    tipo: TipoEvento.academico,
    modalidad: ModalidadEvento.presencial,
  ),
  Evento(
    nombre: 'Seminario de Liderazgo Empresarial',
    fecha: DateTime(2026, 3, 22),
    inscritos: 60,
    cupoMaximo: 80,
    tipo: TipoEvento.corporativo,
    modalidad: ModalidadEvento.hibrido,
  ),
  Evento(
    nombre: 'Taller de Flutter',
    fecha: DateTime(2026, 4, 5),
    inscritos: 18,
    cupoMaximo: 30,
    tipo: TipoEvento.academico,
    modalidad: ModalidadEvento.virtual,
  ),
  Evento(
    nombre: 'Foro de Innovación Empresarial',
    fecha: DateTime(2026, 4, 12),
    inscritos: 73,
    cupoMaximo: 150,
    tipo: TipoEvento.corporativo,
    modalidad: ModalidadEvento.presencial,
  ),
  Evento(
    nombre: 'Jornada de Inteligencia Artificial',
    fecha: DateTime(2026, 4, 20),
    inscritos: 33,
    cupoMaximo: 120,
    tipo: TipoEvento.academico,
    modalidad: ModalidadEvento.hibrido,
  ),
  Evento(
    nombre: 'Capacitación en Gestión de Proyectos',
    fecha: DateTime(2026, 4, 28),
    inscritos: 9,
    cupoMaximo: 40,
    tipo: TipoEvento.corporativo,
    modalidad: ModalidadEvento.virtual,
  ),
];
