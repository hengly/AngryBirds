package com.magicbird.physics;

import box2D.collision.B2Manifold;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.contacts.B2Contact;
import com.magicbird.objects.PhysicsObject;

class ContactListener extends B2ContactListener {

	public function new() {

		super();
	}

	override public function beginContact(contact:B2Contact):Void {
		cast(contact.m_fixtureA.getBody().getUserData(), PhysicsObject).handleBeginContact(contact);
		cast(contact.m_fixtureB.getBody().getUserData(), PhysicsObject).handleBeginContact(contact);
	}

	override public function endContact(contact:B2Contact):Void {

		cast(contact.m_fixtureA.getBody().getUserData(), PhysicsObject).handleEndContact(contact);
		cast(contact.m_fixtureB.getBody().getUserData(), PhysicsObject).handleEndContact(contact);
	}

	override public function preSolve(contact:B2Contact, oldManifold:B2Manifold):Void {

	}

	override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void {
		cast(contact.m_fixtureA.getBody().getUserData(), PhysicsObject).handleImpulse(contact, impulse.normalImpulses[0]);
		cast(contact.m_fixtureB.getBody().getUserData(), PhysicsObject).handleImpulse(contact, impulse.normalImpulses[0]);
	}
}