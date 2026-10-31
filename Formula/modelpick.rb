# Hand-edited on purpose: the update job must put the generated text back.
class Modelpick < Formula
  desc "Picks an LLM subscription, account, model and thinking level from live usage"
  homepage "https://github.com/meatlover/modelpick"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/meatlover/modelpick/releases/download/v0.4.0/modelpick_0.4.0_darwin_arm64.tar.gz"
      sha256 "45abe191fda45038c1e183e766c20d7ecde10f186f415e0f85ec82d2835d67f5"
    end
    on_intel do
      url "https://github.com/meatlover/modelpick/releases/download/v0.4.0/modelpick_0.4.0_darwin_amd64.tar.gz"
      sha256 "fde589a2932a6485e04f170256f3cd380f931995ee2dcbeb87a37c23eac650dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/meatlover/modelpick/releases/download/v0.4.0/modelpick_0.4.0_linux_arm64.tar.gz"
      sha256 "446b16e6d823be97ee7437f24527c6c913fc9b134dd314f353326c801c54163e"
    end
    on_intel do
      url "https://github.com/meatlover/modelpick/releases/download/v0.4.0/modelpick_0.4.0_linux_amd64.tar.gz"
      sha256 "8e989235ea3d703988b2959b5b3d907daeaaf7a5990f4e3fcae2a7608dd175f2"
    end
  end

  def install
    bin.install "modelpick"
    pkgshare.install "config.example.json"
  end

  def caveats
    <<~EOS
      An example config is at
        #{pkgshare}/config.example.json
      Copy it to the path `modelpick config` names, edit it, then run
      `modelpick doctor`.
    EOS
  end

  test do
    assert_equal "modelpick v#{version}", shell_output("#{bin}/modelpick version").strip
  end
end
