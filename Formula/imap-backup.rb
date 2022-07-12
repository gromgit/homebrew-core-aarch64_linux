class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "3397f5126f668ef8ae549afa8e0a4d35370985f693871c69c6f5df932c797d6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0534506025d81847a24c1167e69a5d1000bf25e11b4f3e69a50eb2b8c391b06a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "913bff23e4c77f3114fa215b4da133882ac622c004e169fd9b4555361293ab16"
    sha256 cellar: :any_skip_relocation, monterey:       "0534506025d81847a24c1167e69a5d1000bf25e11b4f3e69a50eb2b8c391b06a"
    sha256 cellar: :any_skip_relocation, big_sur:        "913bff23e4c77f3114fa215b4da133882ac622c004e169fd9b4555361293ab16"
    sha256 cellar: :any_skip_relocation, catalina:       "913bff23e4c77f3114fa215b4da133882ac622c004e169fd9b4555361293ab16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c1ec4edabb3710bc67f786436f7fec4ace15da09f481912277b445ec91924f"
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
