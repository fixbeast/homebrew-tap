# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.1/fixbeast-0.1.1-macos-aarch64.tar.gz"
      sha256 "af54d25b19d74f84474955cc52ea0b39221b371445b9004229b30e24a7f6bd32"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.1/fixbeast-0.1.1-macos-x64.tar.gz"
      sha256 "53eb63450661c7c749af1e8d36be12105175f480e9e51bc5210f18a7fdd2ede9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.1/fixbeast-0.1.1-linux-aarch64.tar.gz"
      sha256 "704c992db5de300087ce39da2d8b4a8cf39a74adb0871efc85de636b80ab3271"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.1/fixbeast-0.1.1-linux-x64.tar.gz"
      sha256 "d23c1ae507b0bf41090cea94023c5bf241c3b74fbd96ba4e9bf0101935705a11"
    end
  end

  def install
    libexec.install "runtime"
    libexec.install "lib"
    libexec.install "bin"
    bin.install_symlink libexec/"bin/fixbeast"
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
