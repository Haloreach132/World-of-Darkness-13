// Held by /obj/machinery/modular_computer to reduce amount of copy-pasted code.
//TODO: REFACTOR THIS SPAGHETTI CODE, MAKE IT A COMPUTER_HARDWARE COMPONENT OR REMOVE IT
/obj/item/modular_computer/processor
	name = "processing unit"
	desc = "You shouldn't see this. If you do, report it."
	icon = null
	icon_state = null
	icon_state_unpowered = null
	icon_state_menu = null
	hardware_flag = 0
	max_bays = 4

	var/obj/machinery/modular_computer/machinery_computer = null

/obj/item/modular_computer/processor/Destroy()
	if(machinery_computer && (machinery_computer.cpu == src))
		machinery_computer.cpu = null
		machinery_computer.UnregisterSignal(src, COMSIG_ATOM_UPDATED_ICON)
	machinery_computer = null
	. = ..()

/obj/item/modular_computer/processor/New(comp)
	..()
	STOP_PROCESSING(SSobj, src) // Processed by its machine

	if(!comp || !istype(comp, /obj/machinery/modular_computer))
		CRASH("Inapropriate type passed to obj/item/modular_computer/processor/New()! Aborting.")
	// Obtain reference to machinery computer
	all_components = list()
	idle_threads = list()
	machinery_computer = comp
	machinery_computer.cpu = src
	hardware_flag = machinery_computer.hardware_flag
	max_hardware_size = machinery_computer.max_hardware_size
	steel_sheet_cost = machinery_computer.steel_sheet_cost
	obj_integrity = machinery_computer.obj_integrity
	max_integrity = machinery_computer.max_integrity
	integrity_failure = machinery_computer.integrity_failure
	base_active_power_usage = machinery_computer.base_active_power_usage
	base_idle_power_usage = machinery_computer.base_idle_power_usage
	machinery_computer.RegisterSignal(src, COMSIG_ATOM_UPDATED_ICON, TYPE_PROC_REF(/atom, update_icon)) //when we update_icon, also update the computer

/obj/item/modular_computer/processor/relay_qdel()
	qdel(machinery_computer)

/obj/item/modular_computer/processor/shutdown_computer()
	if(!machinery_computer)
		return
	..()
	machinery_computer.update_icon()
	return

/obj/item/modular_computer/processor/attack_ghost(mob/user)
	ui_interact(user)

/obj/item/modular_computer/processor/alert_call(datum/computer_file/program/application, alerttext)
	if(!application || !application.alert_able || application.alert_silenced || !alerttext)
		return
	playsound(src, 'sound/machines/twobeep_high.ogg', 50, TRUE)
	machinery_computer.visible_message("<span class='notice'>The [src] displays a [application.filedesc] notification: [alerttext]</span>")
