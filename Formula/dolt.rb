class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.19.1.tar.gz"
  sha256 "cee09d04666869eb292478b2b58cb19fed886f361cb2145abcea5df0f82ec3f2"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "db5eaf089b049c8b1c4bcb6abccd03663c6ca3b380459a230af78dd8300e453a" => :catalina
    sha256 "e1a035e0ed0aa76d22a2b62b87a37ce3eca5d83edca8ce1790beeffc661b9464" => :mojave
    sha256 "e27137fa0d19b4344c86a77b82168ee8e3fafd73764f4be6e2e1430af3a03100" => :high_sierra
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
