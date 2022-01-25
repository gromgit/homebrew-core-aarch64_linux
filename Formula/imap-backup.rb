class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "6e72a20b04e6850abf1aac579a6a781850adb7b827394df31415a32ecc325856"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd5f4adce2647c914cc2d99d94b62dc46c38aa1cbd1098e4990360a99239878"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87ce587f1af3a44e4af31438ebbbef1491f48c52e319a004babddabeafbfdf09"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd5f4adce2647c914cc2d99d94b62dc46c38aa1cbd1098e4990360a99239878"
    sha256 cellar: :any_skip_relocation, big_sur:        "87ce587f1af3a44e4af31438ebbbef1491f48c52e319a004babddabeafbfdf09"
    sha256 cellar: :any_skip_relocation, catalina:       "87ce587f1af3a44e4af31438ebbbef1491f48c52e319a004babddabeafbfdf09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9aaa2500a3942af2008b5ee2e322b787e811744bb52666b9edcb4e000dab7da"
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
