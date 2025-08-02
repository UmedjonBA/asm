use eframe::egui;

struct SimpleApp {
    input_text: String,
    result_text: String,
}

impl Default for SimpleApp {
    fn default() -> Self {
        Self {
            input_text: String::new(),
            result_text: "Результат появится здесь".to_string(),
        }
    }
}

impl eframe::App for SimpleApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("Простое GUI приложение");
            
            ui.add_space(20.0);
            
            ui.horizontal(|ui| {
                ui.label("Введите текст:");
                ui.text_edit_singleline(&mut self.input_text);
            });
            
            ui.add_space(10.0);
            
            if ui.button("Обработать").clicked() {
                if !self.input_text.is_empty() {
                    self.result_text = format!("Вы ввели: {}", self.input_text);
                } else {
                    self.result_text = "Введите текст!".to_string();
                }
            }
            
            ui.add_space(20.0);
            
            ui.label(&self.result_text);
        });
    }
}

fn main() -> Result<(), eframe::Error> {
    let options = eframe::NativeOptions {
        initial_window_size: Some(egui::vec2(400.0, 300.0)),
        ..Default::default()
    };
    
    eframe::run_native(
        "Простое GUI приложение",
        options,
        Box::new(|_cc| Box::new(SimpleApp::default())),
    )
}