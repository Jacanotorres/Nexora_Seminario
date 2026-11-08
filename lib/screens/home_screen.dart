import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';

enum _Seccion {
  eventos('Eventos', Icons.event_outlined),
  inscripciones('Mis Inscripciones', Icons.confirmation_number_outlined),
  certificados('Certificados', Icons.workspace_premium_outlined),
  perfil('Perfil', Icons.person_outline);

  const _Seccion(this.etiqueta, this.icono);
  final String etiqueta;
  final IconData icono;
}

/// Filtro del catálogo: un tipo, una modalidad o todos.
class _Filtro {
  const _Filtro(this.etiqueta, this.coincide);
  final String etiqueta;
  final bool Function(Evento) coincide;
}

final _filtros = <_Filtro>[
  _Filtro('Todos', (_) => true),
  for (final t in TipoEvento.values) _Filtro(t.etiqueta, (e) => e.tipo == t),
  for (final m in ModalidadEvento.values)
    _Filtro(m.etiqueta, (e) => e.modalidad == m),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.nombreUsuario,
    this.onCerrarSesion,
  });

  final String nombreUsuario;
  final VoidCallback? onCerrarSesion;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _Seccion _seccion = _Seccion.eventos;
  int _filtro = 0;
  String _busqueda = '';

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth >= 900;
        final contenido = _Contenido(
          nombreUsuario: widget.nombreUsuario,
          seccion: _seccion,
          filtro: _filtro,
          busqueda: _busqueda,
          compacto: !ancho,
          onFiltro: (i) => setState(() => _filtro = i),
          onBusqueda: (v) => setState(() => _busqueda = v),
          onAviso: _aviso,
        );

        if (!ancho) {
          return Scaffold(
            body: SafeArea(child: contenido),
            bottomNavigationBar: NavigationBar(
              backgroundColor: NexoraColors.sidebar,
              indicatorColor: NexoraColors.accent.withValues(alpha: 0.3),
              selectedIndex: _seccion.index,
              onDestinationSelected: (i) =>
                  setState(() => _seccion = _Seccion.values[i]),
              destinations: [
                for (final s in _Seccion.values)
                  NavigationDestination(
                    icon: Icon(s.icono),
                    label: s == _Seccion.inscripciones
                        ? 'Inscripciones'
                        : s.etiqueta,
                  ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              _Barra(
                seleccion: _seccion,
                onSeleccion: (s) => setState(() => _seccion = s),
                onConfiguracion: () => _aviso('Configuración: próximamente'),
                onCerrarSesion: widget.onCerrarSesion,
              ),
              Expanded(child: contenido),
            ],
          ),
        );
      },
    );
  }
}

class _Barra extends StatelessWidget {
  const _Barra({
    required this.seleccion,
    required this.onSeleccion,
    required this.onConfiguracion,
    required this.onCerrarSesion,
  });

  final _Seccion seleccion;
  final ValueChanged<_Seccion> onSeleccion;
  final VoidCallback onConfiguracion;
  final VoidCallback? onCerrarSesion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: NexoraColors.sidebar,
        border: Border(right: BorderSide(color: NexoraColors.border)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: NexoraColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'N',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXORA',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Gestión de Eventos',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: NexoraColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          for (final s in _Seccion.values)
            _ItemBarra(
              icono: s.icono,
              etiqueta: s.etiqueta,
              activo: s == seleccion,
              onTap: () => onSeleccion(s),
            ),
          const Spacer(),
          _ItemBarra(
            icono: Icons.settings_outlined,
            etiqueta: 'Configuración',
            activo: false,
            onTap: onConfiguracion,
          ),
          _ItemBarra(
            icono: Icons.logout,
            etiqueta: 'Cerrar sesión',
            activo: false,
            onTap: onCerrarSesion ?? () {},
          ),
        ],
      ),
    );
  }
}

class _ItemBarra extends StatelessWidget {
  const _ItemBarra({
    required this.icono,
    required this.etiqueta,
    required this.activo,
    required this.onTap,
  });

  final IconData icono;
  final String etiqueta;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo ? Colors.white : NexoraColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: activo
            ? NexoraColors.accent.withValues(alpha: 0.22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(icono, size: 18, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    etiqueta,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.nombreUsuario,
    required this.seccion,
    required this.filtro,
    required this.busqueda,
    required this.compacto,
    required this.onFiltro,
    required this.onBusqueda,
    required this.onAviso,
  });

  final String nombreUsuario;
  final _Seccion seccion;
  final int filtro;
  final String busqueda;
  final bool compacto;
  final ValueChanged<int> onFiltro;
  final ValueChanged<String> onBusqueda;
  final ValueChanged<String> onAviso;

  @override
  Widget build(BuildContext context) {
    final padding = compacto ? 16.0 : 28.0;
    final buscador = SizedBox(
      width: compacto ? double.infinity : 260,
      child: TextField(
        onChanged: onBusqueda,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          hintText: 'Buscar eventos...',
          prefixIcon: Icon(Icons.search, size: 18),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );

    final eventos = eventosDemo
        .where(_filtros[filtro].coincide)
        .where(
          (e) => e.nombre.toLowerCase().contains(busqueda.trim().toLowerCase()),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(padding, 18, padding, 6),
          child: compacto
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, $nombreUsuario',
                      style: const TextStyle(
                        fontSize: 13,
                        color: NexoraColors.accent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buscador,
                  ],
                )
              : Row(
                  children: [
                    Text(
                      'Hola, $nombreUsuario',
                      style: const TextStyle(
                        fontSize: 13,
                        color: NexoraColors.accent,
                      ),
                    ),
                    const Spacer(),
                    buscador,
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => onAviso('Notificaciones: próximamente'),
                      icon: const Icon(Icons.notifications_none, size: 20),
                    ),
                    IconButton(
                      onPressed: () => onAviso('Configuración: próximamente'),
                      icon: const Icon(Icons.settings_outlined, size: 20),
                    ),
                  ],
                ),
        ),
        const Divider(height: 1, color: NexoraColors.border),
        Expanded(
          child: seccion == _Seccion.eventos
              ? _Catalogo(
                  padding: padding,
                  compacto: compacto,
                  filtro: filtro,
                  eventos: eventos,
                  onFiltro: onFiltro,
                  onAviso: onAviso,
                )
              : Center(
                  child: Text(
                    '${seccion.etiqueta}: próximamente',
                    style: const TextStyle(color: NexoraColors.textMuted),
                  ),
                ),
        ),
      ],
    );
  }
}

class _Catalogo extends StatelessWidget {
  const _Catalogo({
    required this.padding,
    required this.compacto,
    required this.filtro,
    required this.eventos,
    required this.onFiltro,
    required this.onAviso,
  });

  final double padding;
  final bool compacto;
  final int filtro;
  final List<Evento> eventos;
  final ValueChanged<int> onFiltro;
  final ValueChanged<String> onAviso;

  @override
  Widget build(BuildContext context) {
    final crearEvento = FilledButton(
      onPressed: () => onAviso('Crear evento: próximamente'),
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 38),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      child: const Text('Crear Evento'),
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(padding, 22, padding, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Catálogo de Eventos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                crearEvento,
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _filtros.length; i++)
                  ChoiceChip(
                    label: Text(_filtros[i].etiqueta),
                    selected: i == filtro,
                    onSelected: (_) => onFiltro(i),
                    showCheckmark: false,
                    selectedColor: NexoraColors.accent,
                    backgroundColor: NexoraColors.field,
                    side: const BorderSide(color: NexoraColors.border),
                    labelStyle: const TextStyle(fontSize: 11),
                    shape: const StadiumBorder(),
                  ),
              ],
            ),
          ),
        ),
        if (eventos.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No hay eventos que coincidan.',
                style: TextStyle(color: NexoraColors.textMuted),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding, 8, padding, padding),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                // En móvil una sola columna; si no, las fechas se cortan.
                maxCrossAxisExtent: compacto ? 600 : 320,
                mainAxisExtent: 290,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: eventos.length,
              itemBuilder: (context, i) => EventCard(
                evento: eventos[i],
                onInscribirme: () => onAviso('Inscripción: próximamente'),
              ),
            ),
          ),
      ],
    );
  }
}
