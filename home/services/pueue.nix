{ ... }:
{
  services.pueue.enable = true;
  services.pueue.settings = {
    default_parallel_tasks = 4;
  };
}
