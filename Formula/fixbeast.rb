# Homebrew formula template for Fixbeast (ADR-0016, ADR-0017, issue #87). `packaging/homebrew/render`
# fills in the version, the release repository and one checksum per platform; this file is never
# installed as-is. The tarball layout comes from `bin/dist-package` (issue #79):
# fixbeast-<version>-<os>-<arch>/{runtime,lib/fixbeast.jar,bin/fixbeast}.
class Fixbeast < Formula
  desc "Agent-driven loop from a production error to a reviewed fix"
  homepage "https://fixbeast.dev"
  version "0.1.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.2/fixbeast-0.1.2-macos-aarch64.tar.gz"
      sha256 "38c8d357e607769849e74797b8980a842b4a4c776c2f49452a5ed7e2422b449b"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.2/fixbeast-0.1.2-macos-x64.tar.gz"
      sha256 "40b2424fa69f558ec7ff9959eaca0d17236603c03da4dff2268c70cdf152dcc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.2/fixbeast-0.1.2-linux-aarch64.tar.gz"
      sha256 "22d8a2c85ce08adc20a29c3195f55f137dddea1b47e7c91962d5de36bf42a9d2"
    end
    on_intel do
      url "https://github.com/fixbeast/fixbeast/releases/download/v0.1.2/fixbeast-0.1.2-linux-x64.tar.gz"
      sha256 "465a0733668d25a1bb165b4633f0ae00e10d016dea9a8670c394bfdac0422536"
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
