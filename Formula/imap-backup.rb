class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "300a1b25d60ae46e04c9d780825e2c1e60f4330ede586f6500483ee4d358c8d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3018aaa22e702f80113cff400727ee1152f728fe927c94727ef807e6b21b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c782e465b31aee1c9767c1f6baeedc0b42ee969042aa64df1a1fb0b619a8f6"
    sha256 cellar: :any_skip_relocation, monterey:       "2f3018aaa22e702f80113cff400727ee1152f728fe927c94727ef807e6b21b7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "01c782e465b31aee1c9767c1f6baeedc0b42ee969042aa64df1a1fb0b619a8f6"
    sha256 cellar: :any_skip_relocation, catalina:       "01c782e465b31aee1c9767c1f6baeedc0b42ee969042aa64df1a1fb0b619a8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7569cb62c86aa347414a00eed1c425b3fb5011685470770dbb1b9bdddc2a3943"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
  end
end
