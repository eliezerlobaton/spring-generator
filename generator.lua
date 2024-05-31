-- ~/.config/nvim/lua/spring_initializr/initializr.lua
local M = {}

local function create_directory(path)
	os.execute("mkdir -p " .. path)
end

local function create_project_directory(name)
	local project_path = vim.fn.getcwd() .. "/" .. name
	create_directory(project_path)
	return project_path
end

function M.create_project()
	local base_url = "https://start.spring.io/starter.zip"

	-- Solicitar detalles del proyecto
	local project_name = vim.fn.input("Enter project name: ")
	local dependencies = vim.fn.input("Enter dependencies (comma separated): ")
	local type = vim.fn.input("Enter project type (maven-project/gradle-project): ", "maven-project")
	local language = vim.fn.input("Enter language (java/kotlin/groovy): ", "java")
	local boot_version = vim.fn.input("Enter Spring Boot version: ", "2.7.0")
	local group_id = vim.fn.input("Enter group ID: ", "com.example")
	local artifact_id = vim.fn.input("Enter artifact ID: ", project_name)
	local package_name = vim.fn.input("Enter package name: ", group_id .. "." .. artifact_id)
	local java_version = vim.fn.input("Enter Java version: ", "17")

	-- Crear URL de solicitud
	local request_url = string.format(
		"%s?type=%s&language=%s&bootVersion=%s&baseDir=%s&groupId=%s&artifactId=%s&name=%s&packageName=%s&javaVersion=%s&dependencies=%s",
		base_url,
		type,
		language,
		boot_version,
		project_name,
		group_id,
		artifact_id,
		project_name,
		package_name,
		java_version,
		dependencies
	)

	-- Crear directorio del proyecto
	local project_path = create_project_directory(project_name)

	-- Descargar y descomprimir el proyecto
	local zip_path = project_path .. "/" .. project_name .. ".zip"
	os.execute("curl -o " .. zip_path .. ' "' .. request_url .. '"')
	os.execute("unzip " .. zip_path .. " -d " .. project_path)
	os.execute("rm " .. zip_path)

	print("Spring Boot project " .. project_name .. " created.")
end

return M
