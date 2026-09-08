# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.0/fixbeast-0.1.0-macos-aarch64.tar.gz"
      sha256 "ec7da16400081de03f213b88871d5ed0e0cf3cf546201d84b4c8582f72abb619"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.0/fixbeast-0.1.0-macos-x64.tar.gz"
      sha256 "3466f8350a53eb49e184a0c680305815792d8728e83802233a16bb97d945a7dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.0/fixbeast-0.1.0-linux-aarch64.tar.gz"
      sha256 "51c16302f334a27bf8a244d4d5fbe78e33144eb61d16fbd7d41269ff9ad692bf"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.0/fixbeast-0.1.0-linux-x64.tar.gz"
      sha256 "653dd03f913a8e49981cbba20745e8c801ad1fc4ea2a2e59773a18a66336f0b1"
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
