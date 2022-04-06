/datum/reagent/alchemy
	var/alchemy_skill = 0
	metabolization_rate = 1
	overdose_threshold = 30
	reagent_state = LIQUID

/datum/reagent/alchemy/bridge_of_ttf
	name = "Bridge of the True Faith"
	id = "bridge_of_ttf"
	description = "You can walk on air. At least a short ways."
	color = "#B6766F" // rgb: 200, 165, 220

/datum/reagent/alchemy/impossible_targets
	name = "Impossible Targets"
	id = "impossible_targets"
	description = "The right potion if you want neither bullets nor arrows to ever catch you."
	color = "#AAB66F" // rgb: 200, 165, 220

/datum/reagent/alchemy/thief_friend
	name = "Thief's Friend"
	id = "thief_friend"
	description = "Make you invisible for short duration of time."
	var/mob/living/owner
	color = "#5CA44D" // rgb: 200, 165, 220

/datum/reagent/alchemy/thief_friend/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!istype(M))
		return
	if(!istype(M, /mob/living))
		return
	if(!owner)
		owner = M

	if(owner.alpha > 15)
		owner.alpha = 15
	if(alchemy_skill)
		holder.remove_reagent(id, metabolization_rate - (alchemy_skill / 20))
	else
		holder.remove_reagent(id, metabolization_rate)
	return

/datum/reagent/alchemy/thief_friend/on_remove(var/data)
	owner.alpha = 255
	return

/datum/reagent/alchemy/angel_mercy
	name = "Angel's Mercy"
	id = "angel_mercy"
	description = "Healing potion."
	color = "#EBE65D" // rgb: 200, 165, 220

/datum/reagent/alchemy/angel_mercy/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!istype(M))
		return
	if(!istype(M, /mob/living))
		return
	if(!alchemy_skill)
		M.adjustToxLoss(-0.5)
		M.adjustOxyLoss(-0.5)
		M.adjustBruteLoss(-0.5)
		M.adjustFireLoss(-0.5)
	else
		M.adjustToxLoss(-alchemy_skill * 0.5)
		M.adjustOxyLoss(-alchemy_skill * 0.5)
		M.adjustBruteLoss(-alchemy_skill * 0.5)
		M.adjustFireLoss(-alchemy_skill * 0.5)

	holder.remove_reagent(id, metabolization_rate)
	return

/datum/reagent/alchemy/lucky_shot
	name = "Lucky Shot"
	id = "lucky_shot"
	description = "Makes you never miss."
	color = "#5D5DEB" // rgb: 200, 165, 220

/datum/reagent/alchemy/rotcleaner
	name = "Rotcleaner"
	id = "rotcleaner"
	description = "Helps with necrosis, can be applied locally."
	color = "#DC5DEB" // rgb: 200, 165, 220

/datum/reagent/alchemy/rotcleaner/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!istype(M))
		return
	if(!istype(M, /mob/living/carbon/human))
		return
	if(!alchemy_skill)
		return
	var/mob/living/carbon/human/H = M

	for(var/datum/organ/O in H.organs)
		if(istype(O, /datum/organ/external))
			var/datum/organ/external/E = O
			for(var/datum/wound/W in E.wounds)
				W.germ_level -= alchemy_skill
			if((E.status & ORGAN_DEAD) && alchemy_skill > 4)
				E.status &= ~ORGAN_DEAD
				holder.remove_reagent(id, volume)
		O.germ_level -= alchemy_skill

	holder.remove_reagent(id, volume)
	return

/datum/reagent/alchemy/berserker_sweat
	name = "Berserker's Sweat"
	id = "berserker_sweat"
	description = "Cave Buffout, right from the soil."
	color = "#AE0600"

/datum/reagent/alchemy/berserker_sweat/on_mob_life(var/mob/living/carbon/human/M as mob, var/alien)
	if(!istype(M))
		return
	if(!istype(M, /mob/living/carbon/human))
		return

	var/duration = 300
	var/stat_buff = 0.2
	if(alchemy_skill)
		stat_buff *= alchemy_skill
		duration *= alchemy_skill

	M.my_stats.st += stat_buff * volume
	duration *= volume

	holder.remove_reagent(id, volume)
	return M.add_stats(-1 * stat_buff,0, 0, 0)