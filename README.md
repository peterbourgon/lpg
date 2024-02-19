# LPG

Run local Prometheus and Grafana instances, to observe local services.

# Instructions

Edit the `scrape_configs` section of `prometheus.yml` to point to the instances
of the services that you're running locally.

Run `make install`, which will download and install Prometheus and Grafana to
/tmp/lpg, and copy over the config files from this repo.

Run `make run`, which will start local instances of Prometheus and Grafana in a
single "view". Prometheus has log lines starting with `[P ]` and will be running
on http://localhost:9090. Grafana has log lines starting with `[ G]` and will be
running on http://localhost:3000. The default Grafana username/password is
admin/admin.

See the Makefile to change the software versions, more targets, etc.
