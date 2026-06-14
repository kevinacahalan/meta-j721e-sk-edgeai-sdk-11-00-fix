# meta-j721e-sk-edgeai-sdk-11-00-fix

Small Yocto layer that fixes the TI Edge AI SDK 11.00 image build for the SK-TDA4VM / J721E-SK evaluation board.

## What this layer fixes

This layer adds a `.bbappend` for `edgeai-tidl-models` and replaces only the upstream `do_fetch()` task from `meta-edgeai/recipes-tisdk/edgeai-components/edgeai-tidl-models.bb`.
The upstream SDK 11.00 recipe fetches models using `EDGEAI_SDK_VERSION=11_00_00`, but the local setup needs the `11_00_04_00` model zoo to run the Edge AI demo applications correctly.

Everything else in the original recipe still comes from `meta-edgeai` unchanged.

## Contents

- `conf/layer.conf`
- `recipes-tisdk/edgeai-components/edgeai-tidl-models.bbappend`

## Build flow

Start with the normal TI Scarthgap-based Yocto build environment as described here:

- https://github.com/TexasInstruments/ti-docker-images?tab=readme-ov-file#2-start-yocto-scarthgap-based-build

Inside your TI build container, do the following steps.

```bash
git clone https://git.ti.com/git/arago-project/oe-layersetup.git tisdk
cd tisdk
./oe-layertool-setup.sh -f configs/processor-sdk-analytics/processor-sdk-analytics-11.00.00-config.txt

cd build
. conf/setenv

echo 'ARAGO_BRAND = "edgeai"' >> conf/local.conf
echo 'MACHINE = "j721e-sk"' >> conf/local.conf
```

Clone this layer, meta-j721e-sk-edgeai-sdk-11-00-fix, into the Yocto sources directory:

```bash
cd ../sources
git clone https://github.com/kevinacahalan/meta-j721e-sk-edgeai-sdk-11-00-fix.git
```

Add the layer to the build with `bitbake-layers`:

```bash
cd ../build
. conf/setenv
bitbake-layers add-layer ../sources/meta-j721e-sk-edgeai-sdk-11-00-fix
```

Build the Edge AI image:

```bash
bitbake -k tisdk-edgeai-image
```

## Notes

- This layer is intended for the TI SDK 11.00.00 Scarthgap-based build flow.
- `layer.conf` declares compatibility with `scarthgap` and depends on `meta-edgeai`.
- The layer should live under the Yocto `sources/` directory so the relative `bitbake-layers add-layer` command above works as shown.

## References

- https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1619144
- https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1628604/tda4vm-ti-sdk-11-00-00-yocto-tisdk-edgeai-image-build-cannot-run-edgeai-demo-apps-on-the-sk-tda4vm-j721e-sk-eval-board

