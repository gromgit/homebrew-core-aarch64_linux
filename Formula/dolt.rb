class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.21.0.tar.gz"
  sha256 "788aa1d906d4ee4e93ed576607a971f803b6fabf2aeb7394cf5b2b1940c4a8e9"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e9165578769716455c70bfd884298869106a7e9d2e3e1050fadd5e328bacf888" => :catalina
    sha256 "de9df4d21f63cb7e44f59fc399b6c34d63fea249a6465c25f867c02500b92ef7" => :mojave
    sha256 "e212e2142fd2a5b97fdfdebf1c251e40025634526d89fbffe5f7afa0aa0c2c61" => :high_sierra
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
