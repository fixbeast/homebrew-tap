# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.5"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.5/fixbeast-0.1.5-macos-aarch64.tar.gz"
      sha256 "07c8ce465d06c61c0c58c688a704d3593e83cccacdb65dcf6ad8e14046f1fd4f"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.5/fixbeast-0.1.5-macos-x64.tar.gz"
      sha256 "0b11606739620f18582796528a64802a7274c1e9ae433ead0f8ab465ea63e37c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.5/fixbeast-0.1.5-linux-aarch64.tar.gz"
      sha256 "533b7335e558033bf426d449a140fc68922c863518ccaaf633ed7287d8743e36"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.5/fixbeast-0.1.5-linux-x64.tar.gz"
      sha256 "46702993faa67ddff61d434c92292713e56c4ba12cccd3d73f8b311217e817ae"
    end
  end

  def install
    libexec.install "runtime"
    libexec.install "lib"
    libexec.install "bin"
    bin.install_symlink libexec/"bin/fixbeast"
  end

  # The one order of steps (#164), as the self-hosting guide states it.
  def caveats
    <<~EOS
      Next: fixbeast init
      then: cd <your repo> && fixbeast installation add
      then: fixbeast doctor
      then: fixbeast service start
      then: open the inbox and log in
      Guide: https://fixbeast.dev/guide
    EOS
  end

  service do
    run [opt_bin/"fixbeast", "serve"]
    keep_alive true
    log_path var/"log/fixbeast.log"
    error_log_path var/"log/fixbeast-error.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fixbeast --version")
  end
end
