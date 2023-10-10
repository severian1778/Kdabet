defmodule Core.Repo.Migrations.Pitch do
  use Ecto.Migration

  def change do

    create table(:pitches, primary_key: false) do
      add :id, :string, primary_key: true
      add :gid, :integer
      add :abid, :integer
      add :pitchid, :integer
      add :pitcherid, :integer
      add :batterid, :integer
      add :pitch_type, :string
      add :des, :string 
      add :ax, :float
      add :ay, :float
      add :az, :float
      add :vx0, :float
      add :vy0, :float
      add :vz0, :float
      add :px, :float
      add :pz, :float
      add :pfx_x, :float
      add :pfx_z, :float
      add :x, :float
      add :y, :float
      add :sz_bot, :float
      add :sz_top, :float
      add :spin_rate, :integer
      add :spin_dir, :integer
      add :break_y, :float
      add :break_length, :float
      add :break_angle, :float
      add :start_speed, :float
      add :end_speed, :float
      add :balls, :integer
      add :strikes, :integer
      add :zone, :integer
    end

    create index(:pitches, [:gid, :abid, :pitchid])  
 
  end
end
