import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../theme/app_theme.dart';

const _meses = [
  'Ene',
  'Feb',
  'Mar',
  'Abr',
  'May',
  'Jun',
  'Jul',
  'Ago',
  'Sep',
  'Oct',
  'Nov',
  'Dic',
];

String _formatearFecha(DateTime f) =>
    '${f.day.toString().padLeft(2, '0')} ${_meses[f.month - 1]} ${f.year}';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.evento,
    required this.onInscribirme,
  });

  final Evento evento;
  final VoidCallback onInscribirme;

  @override
  Widget build(BuildContext context) {
    final corporativo = evento.tipo == TipoEvento.corporativo;
    final tono = corporativo ? NexoraColors.gold : const Color(0xFF9B97FF);

    return Container(
      decoration: BoxDecoration(
        color: NexoraColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NexoraColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Portada: degradado como marcador hasta tener imágenes por evento.
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tono.withValues(alpha: 0.35), NexoraColors.background],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    corporativo
                        ? Icons.business_center_outlined
                        : Icons.school_outlined,
                    size: 40,
                    color: Colors.white38,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: tono.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      evento.tipo.etiqueta,
                      style: TextStyle(fontSize: 10, color: tono),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: NexoraColors.gold,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _formatearFecha(evento.fecha),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: NexoraColors.gold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          '${evento.inscritos} de ${evento.cupoMaximo} cupos',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: NexoraColors.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: onInscribirme,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(38),
                      side: const BorderSide(color: NexoraColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Inscribirme'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
