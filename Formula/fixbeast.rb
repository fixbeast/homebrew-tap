# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.4"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.4/fixbeast-0.1.4-macos-aarch64.tar.gz"
      sha256 "36b8b7fd449ed57e8d5ec95ee095367cfa04fc5649e26e933b954942177f20ba"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.4/fixbeast-0.1.4-macos-x64.tar.gz"
      sha256 "0d7171364521f6e90702733041422a596d001b36be5b491deeedb0f42384d1d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.4/fixbeast-0.1.4-linux-aarch64.tar.gz"
      sha256 "cb4a403e05cd59b6a09359aec8033a0df6910c48a57481f7c13651ec56be3f09"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.4/fixbeast-0.1.4-linux-x64.tar.gz"
      sha256 "0b167c378b19d044fb9cb60501d8a4c75cd229b39b692485494a2a368f0911c4"
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
