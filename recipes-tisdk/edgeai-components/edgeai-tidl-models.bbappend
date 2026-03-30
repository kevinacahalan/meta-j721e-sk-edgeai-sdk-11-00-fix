#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+
# meta-j721e-sk-edgeai-sdk-11-00-fix/recipes-tisdk/edgeai-components/edgeai-tidl-models.bbappend
#
# See: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1619144
# and see: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1628604/tda4vm-ti-sdk-11-00-00-yocto-tisdk-edgeai-image-build-cannot-run-edgeai-demo-apps-on-the-sk-tda4vm-j721e-sk-eval-board
#
# This bbappend replaces only the upstream do_fetch() task from:
# meta-edgeai/recipes-tisdk/edgeai-components/edgeai-tidl-models.bb
#
# The rest of the recipe still comes from meta-edgeai unchanged.
#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+
do_fetch() {
    mkdir -p ${WORKDIR}/script
    cd ${WORKDIR}/script

    VERSION="${SRCREV}"

    # The upstream recipe downloads this helper script dynamically during do_fetch.
    wget https://raw.githubusercontent.com/TexasInstruments/edgeai-gst-apps/${VERSION}/download_models.sh
    chmod +x ./download_models.sh

    # Run the model downloader against the newer model zoo version required locally.
    export SOC="${SOC}"
    export EDGEAI_SDK_VERSION=11_00_04_00
    ./download_models.sh --recommended

    # Restore the original value so later tasks do not inherit the temporary override.
    export EDGEAI_SDK_VERSION=11_00_00
}