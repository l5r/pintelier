defmodule Pintelier.GroupsTest do
  use Pintelier.DataCase

  alias Pintelier.Groups

  describe "groups" do
    alias Pintelier.Groups.Group

    import Pintelier.GroupsFixtures

    @invalid_attrs %{name: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Groups.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Groups.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Group{} = group} = Groups.create_group(valid_attrs)
      assert group.name == "some name"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Group{} = group} = Groups.update_group(group, update_attrs)
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group(group, @invalid_attrs)
      assert group == Groups.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Groups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Groups.change_group(group)
    end
  end

  describe "group_members" do
    alias Pintelier.Groups.GroupMember

    import Pintelier.GroupsFixtures

    @invalid_attrs %{authorization: nil}

    test "list_group_members/0 returns all group_members" do
      group_member = group_member_fixture()
      assert Groups.list_group_members() == [group_member]
    end

    test "get_group_member!/1 returns the group_member with given id" do
      group_member = group_member_fixture()
      assert Groups.get_group_member!(group_member.id) == group_member
    end

    test "create_group_member/1 with valid data creates a group_member" do
      valid_attrs = %{authorization: :member}

      assert {:ok, %GroupMember{} = group_member} = Groups.create_group_member(valid_attrs)
      assert group_member.authorization == :member
    end

    test "create_group_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group_member(@invalid_attrs)
    end

    test "update_group_member/2 with valid data updates the group_member" do
      group_member = group_member_fixture()
      update_attrs = %{authorization: :admin}

      assert {:ok, %GroupMember{} = group_member} = Groups.update_group_member(group_member, update_attrs)
      assert group_member.authorization == :admin
    end

    test "update_group_member/2 with invalid data returns error changeset" do
      group_member = group_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group_member(group_member, @invalid_attrs)
      assert group_member == Groups.get_group_member!(group_member.id)
    end

    test "delete_group_member/1 deletes the group_member" do
      group_member = group_member_fixture()
      assert {:ok, %GroupMember{}} = Groups.delete_group_member(group_member)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group_member!(group_member.id) end
    end

    test "change_group_member/1 returns a group_member changeset" do
      group_member = group_member_fixture()
      assert %Ecto.Changeset{} = Groups.change_group_member(group_member)
    end
  end

  describe "group_invitations" do
    alias Pintelier.Groups.Invitation

    import Pintelier.GroupsFixtures

    @invalid_attrs %{expiration: nil}

    test "list_group_invitations/0 returns all group_invitations" do
      invitation = invitation_fixture()
      assert Groups.list_group_invitations() == [invitation]
    end

    test "get_invitation!/1 returns the invitation with given id" do
      invitation = invitation_fixture()
      assert Groups.get_invitation!(invitation.id) == invitation
    end

    test "create_invitation/1 with valid data creates a invitation" do
      valid_attrs = %{expiration: ~U[2025-03-26 22:11:00Z]}

      assert {:ok, %Invitation{} = invitation} = Groups.create_invitation(valid_attrs)
      assert invitation.expiration == ~U[2025-03-26 22:11:00Z]
    end

    test "create_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_invitation(@invalid_attrs)
    end

    test "update_invitation/2 with valid data updates the invitation" do
      invitation = invitation_fixture()
      update_attrs = %{expiration: ~U[2025-03-27 22:11:00Z]}

      assert {:ok, %Invitation{} = invitation} = Groups.update_invitation(invitation, update_attrs)
      assert invitation.expiration == ~U[2025-03-27 22:11:00Z]
    end

    test "update_invitation/2 with invalid data returns error changeset" do
      invitation = invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_invitation(invitation, @invalid_attrs)
      assert invitation == Groups.get_invitation!(invitation.id)
    end

    test "delete_invitation/1 deletes the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{}} = Groups.delete_invitation(invitation)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_invitation!(invitation.id) end
    end

    test "change_invitation/1 returns a invitation changeset" do
      invitation = invitation_fixture()
      assert %Ecto.Changeset{} = Groups.change_invitation(invitation)
    end
  end

  describe "group_consumptions" do
    alias Pintelier.Groups.GroupConsumption

    import Pintelier.GroupsFixtures

    @invalid_attrs %{}

    test "list_group_consumptions/0 returns all group_consumptions" do
      group_consumption = group_consumption_fixture()
      assert Groups.list_group_consumptions() == [group_consumption]
    end

    test "get_group_consumption!/1 returns the group_consumption with given id" do
      group_consumption = group_consumption_fixture()
      assert Groups.get_group_consumption!(group_consumption.id) == group_consumption
    end

    test "create_group_consumption/1 with valid data creates a group_consumption" do
      valid_attrs = %{}

      assert {:ok, %GroupConsumption{} = group_consumption} = Groups.create_group_consumption(valid_attrs)
    end

    test "create_group_consumption/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group_consumption(@invalid_attrs)
    end

    test "update_group_consumption/2 with valid data updates the group_consumption" do
      group_consumption = group_consumption_fixture()
      update_attrs = %{}

      assert {:ok, %GroupConsumption{} = group_consumption} = Groups.update_group_consumption(group_consumption, update_attrs)
    end

    test "update_group_consumption/2 with invalid data returns error changeset" do
      group_consumption = group_consumption_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group_consumption(group_consumption, @invalid_attrs)
      assert group_consumption == Groups.get_group_consumption!(group_consumption.id)
    end

    test "delete_group_consumption/1 deletes the group_consumption" do
      group_consumption = group_consumption_fixture()
      assert {:ok, %GroupConsumption{}} = Groups.delete_group_consumption(group_consumption)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group_consumption!(group_consumption.id) end
    end

    test "change_group_consumption/1 returns a group_consumption changeset" do
      group_consumption = group_consumption_fixture()
      assert %Ecto.Changeset{} = Groups.change_group_consumption(group_consumption)
    end
  end
end
