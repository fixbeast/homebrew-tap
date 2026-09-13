# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.3/fixbeast-0.1.3-macos-aarch64.tar.gz"
      sha256 "199acd8d863052d523b5cc017046227ec15f40470e4dbe374349a8180bc9b195"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.3/fixbeast-0.1.3-macos-x64.tar.gz"
      sha256 "0ffb64bddf0e48c3db67ae042125d6af1ebeff6ebdd2c950cacf5ffbe5e06036"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.3/fixbeast-0.1.3-linux-aarch64.tar.gz"
      sha256 "e4070a05bfb24520bbfd6aab23a364833463eb417519ad1fb32b4c1409ee07d3"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.3/fixbeast-0.1.3-linux-x64.tar.gz"
      sha256 "526feb4cd4566f325b3436c05219b6ba27bb60d35720fd484fc8b7a7e9e8a1e8"
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
